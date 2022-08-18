FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake zlib1g zlib1g-dev pkg-config openssl libssl-dev curl libcurl4-openssl-dev
RUN git clone https://github.com/ZerBea/hcxtools.git
WORKDIR /hcxtools
RUN CC=afl-clang make
RUN make install
RUN mkdir /pcapCorpus
RUN wget https://www.wireshark.org/download/automated/captures/fuzz-2007-03-07-8496.pcap
RUN wget https://www.wireshark.org/download/automated/captures/fuzz-2007-03-14-3356.pcap
RUN wget https://www.wireshark.org/download/automated/captures/fuzz-2007-03-23-10052.pcap
RUN wget https://www.wireshark.org/download/automated/captures/fuzz-2007-04-25-11110.pcap
RUN wget https://www.wireshark.org/download/automated/captures/fuzz-2007-11-21-10148.pcap
RUN mv *.pcap /pcapCorpus

ENTRYPOINT ["afl-fuzz", "-i", "/pcapCorpus", "-o", "/hcxpcapngtoolOut"]
CMD ["/hcxpcapngtool", "-o", "hash.hc22000", "-E", "wordlist.txt", "@@"]
