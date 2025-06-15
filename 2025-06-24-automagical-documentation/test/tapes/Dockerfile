FROM ghcr.io/charmbracelet/vhs:latest

# Update the list of packages
RUN apt-get update

# Install pre-requisite packages.
RUN apt-get install -y wget

# Get the version of Debian
RUN . /etc/os-release && echo $VERSION_ID && wget -q https://packages.microsoft.com/config/debian/$VERSION_ID/packages-microsoft-prod.deb

# Register the Microsoft repository GPG keys
RUN dpkg -i packages-microsoft-prod.deb

# Delete the Microsoft repository GPG keys file
RUN rm packages-microsoft-prod.deb

# Update the list of packages after we added packages.microsoft.com
RUN apt-get update

###################################
# Install PowerShell
RUN apt-get install -y powershell
