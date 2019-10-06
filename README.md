# ashafer01/unrealircd4

Docker image of UnrealIRCd4 built from source.

The only customization this makes is setting the directive to allow the
`class::options::nofakelag` configuration.

See [Unreal FAQ](https://www.unrealircd.org/docs/FAQ#Why_is_UnrealIRCd_responding_slowly_.28laggy.29._It.27s_only_processing_1_line_per_second.3F.3F)
for the developer's justification for why this requires editing the source to allow.

Note that you still have to add the config option to a class block for this to
take effect.

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
