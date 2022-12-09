FROM --platform=linux/amd64 entropy_base:latest

RUN apt-get update && apt-get install -yq \
  unzip \
  libncurses5-dev \
  liblzma-dev \
  libcurl4-gnutls-dev \
  zlib1g-dev \
  libbz2-dev \
  default-jdk \
  default-jre \
  pigz \
  pv

# Install samtools
RUN curl -L https://github.com/samtools/samtools/releases/download/1.16.1/samtools-1.16.1.tar.bz2 --output /tmp/samtools-1.16.1.tar.bz2 && \
  cd /tmp && tar xjf samtools-1.16.1.tar.bz2 && \
  cd samtools-1.16.1 && \
    ./configure && \
    make && \
    make install

# Install Bowtie2
RUN curl -L https://github.com/BenLangmead/bowtie2/releases/download/v2.5.0/bowtie2-2.5.0-linux-x86_64.zip --output /tmp/bowtie2-2.5.0-linux-x86_64.zip && \
  cd /tmp && unzip bowtie2-2.5.0-linux-x86_64.zip && \
  cp -r bowtie2-2.5.0-linux-x86_64/* /bin && \
  rm -rf bowtie2-2.5.0-linux-x86_64 bowtie2-2.5.0-linux-x86_64.zip

# BBmap: Note this particular version is needed for Shapemapper; breaking changes after it
RUN curl -L https://versaweb.dl.sourceforge.net/project/bbmap/BBMap_37.78.tar.gz --output /tmp/BBMap_37.78.tar.gz && \
  cd /tmp && tar xvzf BBMap_37.78.tar.gz && \
  mv bbmap/* /bin && \
  rm -rf bbmap BBMap_37.78.tar.gz

# Dependencies for RNAstructure and Shapemapper
RUN apt-get update && apt-get install -yq \
  cmake g++ autotools-dev libicu-dev libboost-all-dev ghostscript

# RNAstructure
# Downloaded from: http://rna.urmc.rochester.edu/Releases/current/RNAstructureSource.tgz  
ADD ./src/RNAstructure /root/RNAstructure
RUN cd /root/RNAstructure && make all
ENV PATH="/root/RNAstructure/exe:${PATH}"
ENV DATAPATH=/root/RNAstructure/data_tables

# ShapeMapper
RUN cd /root && git clone --depth 1 --branch pyfix https://github.com/sumslogs/shapemapper2 && \
  cd shapemapper2 && \
  mkdir build && cd build && cmake .. && make
RUN pip install matplotlib==3.3.4
#  cd /root/shapemapper2 && \
#  find ./ \( -type d -name .git -prune \) -o -type f -name "*.py" -print0 | xargs -0 sed -i 's/\"rU\"/\"r\"/g' && \
#  find ./ \( -type d -name .git -prune \) -o -type f -name "*.py" -print0 | xargs -0 sed -i "s/'rU'/'r'/g"
ENV PATH="/root/shapemapper2:${PATH}"

# Superfold
RUN cd /root && git clone --depth 1 --branch pyfix https://github.com/sumslogs/Superfold
ENV PATH="/root/Superfold:${PATH}"

RUN mkdir /component
WORKDIR /component
