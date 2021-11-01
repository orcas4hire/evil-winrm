# Base image
FROM ruby:2.7.4-bullseye as builder
LABEL stage=builder

#Env vars
ENV EVILWINRM_RB_URL="https://raw.githubusercontent.com/Hackplayers/evil-winrm/master/evil-winrm.rb"

RUN gem install \
    winrm \
    winrm-fs \
    stringio \
    logger \
    fileutils

# Set workdir
WORKDIR /opt/

#Install Evil-WinRM
RUN mkdir evil-winrm && \
    wget ${EVILWINRM_RB_URL} \
    -qO /opt/evil-winrm/evil-winrm.rb


################################################################    
# Final image
FROM ruby:2.7.4-slim-bullseye

# Copy built gems for stringio/ffi for this stage
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /opt/evil-winrm /opt/evil-winrm

# Credits
LABEL \
    name="Evil-WinRM" \
    author="CyberVaca cybervaca@gmail.com>" \
    maintainer="OscarAkaElvis <oscar.alfonso.diaz@gmail.com>" \
    description="The ultimate WinRM shell for hacking/pentesting"
  
# Create user and directories
# Add regular user and make it owner of these folders
RUN chmod +x /opt/evil-winrm/*.rb \
 && useradd myuser \
 && mkdir -p /data /ps1_scripts /exe_files \
 && chown root:myuser /data /ps1_scripts /exe_files

# Set user to run commands from now on
USER myuser

WORKDIR /data/

# Start command (launch Evil-WinRM)
ENTRYPOINT ["/opt/evil-winrm/evil-winrm.rb"]
