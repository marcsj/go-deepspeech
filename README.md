
Golang bindings for Mozilla's [DeepSpeech](https://github.com/mozilla/DeepSpeech) speech-to-text library.

`go-deepspeech` is a dynamically-linked version of deepspeech using cpu and compatible with version `v0.9.0`.

# Running
Build & run with docker:

    docker build -f Dockerfile -t go-deepspeech .
    docker run go-deepspeech

# Examples
## Get the pre-trained model and scorer

Run the following commands:

    $ mkdir /tmp/deepspeech
    $ cd /tmp/deepspeech
    $ wget https://github.com/mozilla/DeepSpeech/releases/download/v0.9.0/deepspeech-0.9.0-models.pbmm
    $ wget https://github.com/mozilla/DeepSpeech/releases/download/v0.9.0/deepspeech-0.9.0-models.scorer
    
## Get the audio files

Run the following commands:

    $ cd /tmp/deepspeech
    $ wget https://github.com/mozilla/DeepSpeech/releases/download/v0.9.0/audio-0.9.0.tar.gz
    $ tar xvfz audio-0.9.0.tar.gz
    
## Use the client

Run the following commands (make sure `$GOPATH/bin` is in your `$PATH`):

    $ cd /tmp/deepspeech
    $ deepspeech -model deepspeech-0.9.0-models.pbmm -scorer deepspeech-0.9.0-models.scorer -audio audio/2830-3980-0043.wav
    
        Text: experience proves this
    
    $ deepspeech -model deepspeech-0.9.0-models.pbmm -scorer deepspeech-0.9.0-models.scorer -audio audio/4507-16021-0012.wav
    
        Text: why should one hall on the way
        
    $ deepspeech -model deepspeech-0.9.0-models.pbmm -scorer deepspeech-0.9.0-models.scorer -audio audio/8455-210777-0068.wav
    
        Text: your power is sufficient i said
