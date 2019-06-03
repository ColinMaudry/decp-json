FROM python:2-slim
RUN apt-get update
RUN apt-get install -y jq xsltproc libxml2-utils git build-essential
WORKDIR /deps
RUN git clone https://github.com/edsu/json2xml.git
RUN git clone https://github.com/Cheedoong/xml2json.git
RUN cd xml2json && make
ENV PATH="$PATH:/deps/xml2json"
ENV PATH="$PATH:/deps/json2xml"
