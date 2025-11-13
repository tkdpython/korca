FROM python:3.10.16-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install basic utilities and dependencies
RUN apt-get update && apt-get install -y \
    wget \
    git \
    curl \
    vim \
    nano \
    watch \
    tmux \
    sshpass \
    gnupg \
    lsb-release \
    ca-certificates \
    build-essential \
    libffi-dev \
    libssl-dev \
    libncurses5 \
    libaio1 \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Ansible v2.9.27
RUN pip install --upgrade pip && \
    pip install ansible==2.9.27 openpyxl pandas kubernetes

# Install Docker CLI
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce-cli docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/*

# Install kubectl v1.26.13
RUN curl -LO https://dl.k8s.io/release/v1.26.13/bin/linux/amd64/kubectl && \
    install -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Install k9s (latest stable)
RUN K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep tag_name | cut -d '"' -f4) && \
    wget https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz && \
    tar -xzf k9s_Linux_amd64.tar.gz && \
    mv k9s /usr/local/bin/ && \
    rm k9s_Linux_amd64.tar.gz
# ...existing code...

# Set prompt to "korca: <current path>" with red background
RUN echo 'export PS1="\[\e[41;30m\]korca: \w\[\e[0m\] > "' >> /etc/bash.bashrc

# ...existing code...
CMD ["/bin/bash"]