import ctcsound

cs = ctcsound.Csound()


# Get version numbers
v, va = cs.version(), cs.APIVersion()
print("Raw version values: {}, {}".format(v, va))

# Format version numbers
major, v = int(v/1000), v%1000
minor, patch = int(v/10), v%10
print('Csound version: {0}.{1:02d}.{2}'.format(major, minor, patch))
major, minor = int(va/100), va%100
print('API version: {0}.{1:02}'.format(major, minor))

# Get sample size
sampleSize = cs.sizeOfMYFLT()
print('Sample size: {}'.format(sampleSize))

# Show the value of the pointer to the Csound instance
print("Value of the opaque pointer: {}".format(cs.csound()))