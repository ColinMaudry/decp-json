FROM python:2-slim
RUN apt-get update
RUN apt-get install -y jq xsltproc libxml2-utils git build-essential curl zip wget python3 python3-venv python-pip
WORKDIR /deps
RUN git clone https://github.com/edsu/json2xml.git
RUN git clone https://github.com/Cheedoong/xml2json.git
RUN git clone https://github.com/OpenDataServices/flatten-tool.git
RUN cd xml2json && make
RUN cd /deps/flatten-tool
RUN python3 -m venv .ve
RUN source .ve/bin/activate
RUN pip install -r requirements.txt
ENV PATH="$PATH:/deps/xml2json"
ENV PATH="$PATH:/deps/json2xml"
