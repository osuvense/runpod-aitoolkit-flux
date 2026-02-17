FROM runpod/pytorch:2.1.0-py3.10-cuda12.1.1-devel-ubuntu22.04

WORKDIR /workspace

# Install Node.js 20.x (required for AI-Toolkit Web UI)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Clone AI-Toolkit
RUN git clone https://github.com/ostris/ai-toolkit.git /app/ai-toolkit && \
    cd /app/ai-toolkit && \
    git submodule update --init --recursive

# Install Python dependencies
RUN cd /app/ai-toolkit && \
    pip install --no-cache-dir torch==2.1.0 torchvision==0.16.0 --index-url https://download.pytorch.org/whl/cu121 && \
    pip install --no-cache-dir -r requirements.txt

# Install Node.js dependencies (Web UI)
RUN cd /app/ai-toolkit && npm install

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
