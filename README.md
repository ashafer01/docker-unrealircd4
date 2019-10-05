# ashafer01/unrealircd4

Docker image of UnrealIRCd4 built from source.

The only customization this makes is setting the directive to allow the
`class::options::nofakelag` configuration.

See [Unreal FAQ](https://www.unrealircd.org/docs/FAQ#Why_is_UnrealIRCd_responding_slowly_.28laggy.29._It.27s_only_processing_1_line_per_second.3F.3F)
for the developer's justification for why this requires editing the source to allow.

Note that you still have to add the config option to a class block for this to
take effect.
