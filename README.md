# xplex
## the renaissance will not be televised
## IT WILL BE STREAMED LIVE!

`xplex` is:

- free and open source
- containerized & self-hosted
- performance & resource efficient
- multi-streaming service

> [!NOTE]  
> This `readme` is meant for developers, trying to look under the hood of the technology stack. If you're a streamer, looking for certain information about getting `xplex` to work - the [website](https://xplex.me) should be where you find it.

### Abstract
We're using [nginx-rtmp-module](https://github.com/arut/nginx-rtmp-module) to build & deploy a custom `NGINX` server instance, which uses multiple `push` directives inside `rtmp::server::application` configuration context, to split the incoming stream into `n-number` of identical streams (without any transcoding) to all the `push` ingests.

As long as the network bandwidth is capable of handling `(n+1)*bitrate`, this should work fine, as the other system resource requirements are quite bare minimal.

At a more abstract level, `xplex` is a docker container, with custom `NGINX` server built-in and running to handle RTMP connections, and is optimized to split incoming audio/video streams into multiple preconfigured ingest points (but can be used to do other things as well).

### Development
To get set up and hacking on `xplex`, you'd need a (preferably linux) workstation with:

- Git ([guide](https://git-scm.com/docs))
- Docker ([guide](https://docs.docker.com/))
- NodeJS & npm ([download](https://nodejs.org/en/download/))
- Terminal emulator(s) & text editor(s) of your choice
- `[Optional]` VLC media player ([download](https://www.videolan.org/vlc/#download))
- `[Optional]` OBS Studio ([download](https://obsproject.com/download)/[guide](https://github.com/obsproject/obs-studio/wiki))

Next up, you'd want to clone the repo first:

```bash
git clone https://github.com/debloper/xplex.git
cd xplex
```

At this point, if `docker` service is up, then try running:

```bash
./build.sh xplex
# convenience script for `docker build --target xplex -t xplex/xplex:latest .`
```

If everything went alright, you should have a new image created called `xplex/xplex:latest` which you can now run with:

```bash
docker run -it -p 80:80 -p 1935:1935 xplex/xplex
```

Open your browser, and visit [http://localhost/](http://localhost/) - you should see the `xplex HQ` dashboard. This is where you would add your streaming ingests for xplex to push streams to.

Now, **to confirm if the RTMP streaming is working**, you'd need:

- streaming account(s) on Twitch/YouTube/Mixer etc. services
  - review all the settings in the streamers' dashboard(s)
  - get ingest URLs for respective services from the dashboard(s)
- a stream broadcasting tool ([OBS Studio recommended](https://obsproject.com/wiki/))
  - create a scene with desktop capture or webcam input to stream
  - set `File::Settings::Stream::URL` to `rtmp://localhost:1935/live`
  - change other settings as per streaming service guidelines, for e.g.
    - [Twitch](https://stream.twitch.tv/)
    - [YouTube](https://support.google.com/youtube/answer/2853702)
    - [Mixer](https://watchbeam.zendesk.com/hc/articles/217386946)

Add the streaming ingest endpoints to xplex HQ dashboard & make sure to `APPLY CHANGES` before streaming.

If everything went OK so far, then start the stream from OBS, and you should be able to visit your channel(s) to watch it live.

### Contribute
Whether it's a suggestion, feature request or a patch itself, contributions to `xplex` are highly appreciated. A software can never be a very good one when it's just a lone-wolf's pipe dream; please gather around and make it better together.

Use the 3Es for prioritization & decision making; which says the solution has to aspire to be:

1. effective
2. efficient
3. elegant

...and in that order.

There's no restrictive & pedantic contributing guideline(s), however:

- assume good faith
- be considerate
- be concise

By contributing to `xplex` with code-examples/pull-requests, you agree to have those codes published as permissive open source software, as detailed in the next section.

### License
Unless otherwise mentioned, all individual components, files, and also as a whole - `xplex` is available under [MPL 2.0](https://www.mozilla.org/en-US/MPL/2.0/). Non-text files (images, icons, PDFs etc.), unless otherwise mentioned, are available under [CC-BY-SA-3.0](https://creativecommons.org/licenses/by-sa/3.0/). If you're building something on/with `xplex`, you have my best wishes, and I'd love to hear about it!
