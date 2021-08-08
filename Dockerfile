# build the executable
FROM ubuntu as builder

ARG DEBIAN_FRONTEND=noninteractive

#RUN apk add --no-cache go git g++ gcc libgcc tar xz util-linux-dev libstdc++6 libc-dev
RUN apt-get update && apt-get install -y golang gcc git libstdc++6 libc-dev wget g++ tar

# get deepspeech native
RUN mkdir -p /tmp/deepspeech/lib && mkdir -p /tmp/deepspeech/include
RUN wget https://github.com/mozilla/DeepSpeech/releases/download/v0.9.0/native_client.amd64.cpu.linux.tar.xz \
&& tar -xf native_client.amd64.cpu.linux.tar.xz -C /tmp/deepspeech/lib && rm native_client.amd64.cpu.linux.tar.xz
RUN wget https://github.com/mozilla/DeepSpeech/raw/v0.9.0/native_client/deepspeech.h \
&& mv deepspeech.h /tmp/deepspeech/include/deepspeech.h

# get the pre-trained model
RUN wget https://github.com/mozilla/DeepSpeech/releases/download/v0.9.0/deepspeech-0.9.0-models.pbmm
RUN wget https://github.com/mozilla/DeepSpeech/releases/download/v0.9.0/deepspeech-0.9.0-models.scorer

# deepspeech building env
ENV CGO_LDFLAGS="-L/tmp/deepspeech/lib/"
ENV CGO_CXXFLAGS="-I/tmp/deepspeech/include/"
ENV LD_LIBRARY_PATH="/tmp/deepspeech/lib/"

WORKDIR $GOPATH/src/github.com/marcsj/go-deepspeech

# copy context
COPY . ./

# build executable to /app
RUN go build \
    -o /app \
    deepspeech/main.go

# leave building environment
FROM scratch

COPY --from=builder /usr/local/share/ca-certificates /usr/local/share/ca-certificates
COPY --from=builder /etc/ssl/certs /etc/ssl/certs
COPY --from=builder /app /app
COPY --from=builder deepspeech-0.9.0-models.pbmm /
COPY --from=builder deepspeech-0.9.0-models.scorer /

# run the compiled binary
ENTRYPOINT ["/app"]