import sox

soxy = sox.Transformer()
soxy.set_input_format('wav', ignore_length=True)
soxy.silence(1, .015, 1)
soxy.build(CORDELIA_OUT_WAV_temp, CORDELIA_OUT_WAV)
