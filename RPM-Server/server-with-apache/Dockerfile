FROM almalinux:8

RUN dnf install -y createrepo httpd gnupg2 && dnf clean all

WORKDIR /rpms

COPY setup-repo.sh .

# # Copy RPMs into the repo folder (adjust as needed)
# COPY rpms/ /var/www/html/RPM-Repo/

RUN chmod +x setup-repo.sh && ./setup-repo.sh

COPY index.html /var/www/html/

# to supress logs related qualified domain name
# RUN echo "ServerName localhost" >> /etc/httpd/conf/httpd.conf

EXPOSE 80

CMD ["httpd", "-D", "FOREGROUND"]