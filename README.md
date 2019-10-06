# ashafer01/unrealircd4

Docker image of UnrealIRCd4 built from source.

The only customization this makes is setting the directive to allow the
`class::options::nofakelag` configuration.

See [Unreal FAQ](https://www.unrealircd.org/docs/FAQ#Why_is_UnrealIRCd_responding_slowly_.28laggy.29._It.27s_only_processing_1_line_per_second.3F.3F)
for the developer's justification for why this requires editing the source to allow.

Note that you still have to add the config option to a class block for this to
take effect.

## Manual configuration

If you have an existing unreal `conf/` directory, you can mount this at
`/opt/unreal/conf`.

The following procedure is recommended for manually configuring a new
installation:

1. Set up a new config volume (assumes volume `my-unreal-conf` does not exist)

```
docker run -it -v my-unreal-conf:/opt/unreal/conf --rm=true ashafer01/unrealircd4:4.2.4.1 ./regen_cloak_keys.sh
```

2. Edit the config volume from another container

Run the container from the host:
```
docker run -it -v my-unreal-conf:/opt/unreal/conf --rm=true -u irc:irc ashafer01/vim
```

And then on the running container's shell:
```
cd /opt/unreal/config
vim site.conf
```

The `site.conf` file contains all of the essential configuration blocks that
will need to be changed. `unrealircd.conf` and the other existing files should
typically _not_ be changed.

Note that if you add or modify `listen` ports, you'll need to make a custom
image with your own `EXPOSE` directives added.

3. Start the production container

```
docker run -dit -v my-unreal-conf:/opt/unreal/conf --restart=unless-stopped ... ashafer01/unrealircd4:4.2.4.1
```

## Manually building the image from scratch

1. Clone [docker-unreal-build](https://github.com/ashafer01/docker-unreal-build) and make a build
image

```
git clone git@github.com:ashafer01/docker-unreal-build.git
cd docker-unreal-build
docker build -t unrealbuild .
```

2. Create an artifacts directory and run the image with it mounted:

```
mkdir artifacts
chmod a+w artifacts
docker run -it --rm=true -v $PWD/artifacts:/tmp/artifacts unrealbuild
```

3. Clone this repo and move the deb into the build context

```
cd -
git clone git@github.com:ashafer01/docker-unrealircd4.git
cd docker-unrealircd4
mv ../docker-unreal-build/artifcats/* .
```

4. Build the image

```
docker build -t myunreal .
```

5. Run it like so:

```
docker run -d ... myunreal
```
