FROM swift:4.2
ADD . /code
WORKDIR /code
ENV ZONE=
RUN swift build -c release
CMD [".build/release/cf_ddns"]
