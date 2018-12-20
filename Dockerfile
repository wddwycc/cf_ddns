FROM swift:4.2
ADD . /code
WORKDIR /code
ARG zone 
ARG recordType 
ARG recordName 
ARG email 
ARG apiKey
ENV ZONE=${zone} RECORD_TYPE=${recordType} RECORD_NAME=${recordName} EMAIL=${email} API_KEY=${apiKey}
RUN swift build -c release
ENTRYPOINT .build/release/cf_ddns
