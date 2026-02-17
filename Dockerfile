FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-devel

WORKDIR /workspace

# Install system dependencies including git
RUN apt-get update && \
    apt-get install -y git curl build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js 20.x
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Verify installations
RUN node --version && npm --version && git --version

# Clone AI-Toolkit with submodules
RUN git clone --recursive https://github.com/ostris/ai-toolkit.git /app/ai-toolkit

# Install Python dependencies
RUN cd /app/ai-toolkit && \
    pip install --no-cache-dir -r requirements.txt

# Install Node.js dependencies with increased timeout
RUN cd /app/ai-toolkit && \
    npm install --verbose --fetch-timeout=60000 || \
    (echo "First npm install failed, retrying..." && npm install --verbose --fetch-timeout=60000)

# Copy setup script
COPY setup_aitoolkit.sh /setup_aitoolkit.sh
RUN chmod +x /setup_aitoolkit.sh

# Create startup script
RUN echo '#!/bin/bash' > /start.sh && \
    echo '/setup_aitoolkit.sh &' >> /start.sh && \
    echo 'sleep 5' >> /start.sh && \
    echo 'cd /app/ai-toolkit && npm start' >> /start.sh && \
    chmod +x /start.sh

EXPOSE 8675 8080

CMD ["/start.sh"]
