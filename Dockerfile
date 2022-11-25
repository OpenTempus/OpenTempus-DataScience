FROM r-base

RUN apt update
RUN apt install -y curl
RUN apt install -y dirmngr gnupg apt-transport-https ca-certificates software-properties-common
RUN apt install -y libcurl4-openssl-dev build-essential

COPY . /usr/local/src/myscripts
WORKDIR /usr/local/src/myscripts

CMD ["Rscript", "myscript.R"]


