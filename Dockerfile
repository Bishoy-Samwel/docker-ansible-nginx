FROM ubuntu
RUN apt update && apt install  ssh sudo -y
RUN adduser bob
RUN echo "bob:123" | chpasswd
RUN usermod -aG sudo bob
ENTRYPOINT service ssh start && bash