import librosa
from numpy.polynomial import polynomial as P

import numpy as np
import scipy, scipy.io, scipy.io.wavfile, scipy.signal

import matplotlib.pyplot as plt

def print_info(arr):
    # Print dimension
    print("Dimension:", arr.ndim)

    # Print shape
    print("Shape:", arr.shape)

    # Print size (total number of elements)
    print("Size:", arr.size)

    # Print data type
    print("Data type:", arr.dtype)

    # Print strides (the number of bytes to step in each dimension when traversing the array)
    print("Strides:", arr.strides)

    # Print itemsize (the size in bytes of each element)
    print("Item size (bytes):", arr.itemsize)

    # Print a summary of the array content
    print("Array:")
    max_elements_to_display = 10  # You can adjust this number as needed
    if arr.size <= 2 * max_elements_to_display:
        # If the array is small, print the entire content
        print(arr)
    else:
        # Otherwise, print the beginning and end of the array
        print(np.concatenate((arr[:max_elements_to_display], arr[-max_elements_to_display:])))

def levinson_1d(r, order):
    """Levinson-Durbin recursion, to efficiently solve symmetric linear systems
    with toeplitz structure.

    Parameters
    ---------
    r : array-like
        input array to invert (since the matrix is symmetric Toeplitz, the
        corresponding pxp matrix is defined by p items only). Generally the
        autocorrelation of the signal for linear prediction coefficients
        estimation. The first item must be a non zero real.

    Notes
    ----
    This implementation is in python, hence unsuitable for any serious
    computation. Use it as educational and reference purpose only.

    Levinson is a well-known algorithm to solve the Hermitian toeplitz
    equation:

                       _          _
        -R[1] = R[0]   R[1]   ... R[p-1]    a[1]
         :      :      :          :      *  :
         :      :      :          _      *  :
        -R[p] = R[p-1] R[p-2] ... R[0]      a[p]
                       _
    with respect to a (  is the complex conjugate). Using the special symmetry
    in the matrix, the inversion can be done in O(p^2) instead of O(p^3).
    """
    r = np.atleast_1d(r)
    if r.ndim > 1:
        raise ValueError("Only rank 1 are supported for now.")

    n = r.size
    if n < 1:
        raise ValueError("Cannot operate on empty array !")
    elif order > n - 1:
        raise ValueError("Order should be <= size-1")

    if not np.isreal(r[0]):
        raise ValueError("First item of input must be real.")
    elif not np.isfinite(1/r[0]):
        raise ValueError("First item should be != 0")

    # Estimated coefficients
    a = np.empty(order+1, r.dtype)
    # temporary array
    t = np.empty(order+1, r.dtype)
    # Reflection coefficients
    k = np.empty(order, r.dtype)

    a[0] = 1.
    e = r[0]

    for i in range(1, order+1):
        acc = r[i]
        for j in range(1, i):
            acc += a[j] * r[i-j]
        k[i-1] = -acc / e
        a[i] = k[i-1]

        for j in range(order):
            t[j] = a[j]

        for j in range(1, i):
            a[j] += k[i-1] * np.conj(t[i-j])

        e *= 1 - k[i-1] * np.conj(k[i-1])

    return a, e, k

def lsp_to_lpc(lsp):  
    """Convert line spectral pairs to LPC"""
    ps = np.concatenate((lsp[:,0], -lsp[::-1,0], [np.pi]))
    qs = np.concatenate((lsp[:,1], [0], -lsp[::-1,1]))
    
    p = np.cos(ps) - np.sin(ps)*1.0j
    q = np.cos(qs) - np.sin(qs)*1.0j
    
    p = np.real(P.polyfromroots(p))
    q = -np.real(P.polyfromroots(q))
    
    a = 0.5 * (p+q)
    return a[:-1]

def lpc_noise_synthesize(lpc, samples=10000):
    """Apply LPC coefficients to white noise"""
    phase = np.random.uniform(0,0.5,(samples))
    signal= scipy.signal.lfilter([1.], lpc, phase)        
    return signal
    
def lpc_buzz_synthesize(lpc, f, sr, samples=10000):       
    """Apply LPC coefficients to a sawtooth with the given frequency and sample rate"""
    phase = scipy.signal.sawtooth(2*np.pi*f*np.arange(samples)/(sr))
    signal= scipy.signal.lfilter([1.], lpc, phase)        
    return signal

def lpc_to_lsp(lpc):    
    """Convert LPC to line spectral pairs"""
    l = len(lpc)+1
    a = np.zeros((l,))        
    a[0:-1] = lpc
    p = np.zeros((l,))
    q = np.zeros((l,))    
    for i in range(l):
        j = l-i-1
        p[i] = a[i] + a[j]
        q[i] = a[i] - a[j]
    
    ps = np.sort(np.angle(np.roots(p)))
    qs = np.sort(np.angle(np.roots(q)))            
    lsp = np.vstack([ps[:len(ps)//2],qs[:len(qs)//2]]).T    
    return lsp

def lpc_to_formants(lpc, sr):    
    """Convert LPC to formants    
    """
        
    # extract roots, get angle and radius
    roots = np.roots(lpc)
    
    pos_roots = roots[np.imag(roots)>=0]
    if len(pos_roots)<len(roots)//2:
        pos_roots = list(pos_roots) + [0] * (len(roots)//2 - len(pos_roots))
    if len(pos_roots)>len(roots)//2:
        pos_roots = pos_roots[:len(roots)//2]
    
    w = np.angle(pos_roots)
    a = np.abs(pos_roots)
    
    order = np.argsort(w)
    w = w[order]
    a = a[order]
    
    freqs = w * (sr/(2*np.pi))
    bws =  -0.5 * (sr/(2*np.pi)) * np.log(a)    
    
    # exclude DC and sr/2 frequencies
    return freqs, bws

def load_wave(fname):
    """Load a 16 bit wave file and return normalised in 0,1 range"""
    # load and return a wave file
    sr, wave = scipy.io.wavfile.read(fname)
    print_info(wave)
    audio_data, sr = librosa.load(fname, mono=None, sr=None)
    print_info(audio_data)
    return wave/32768.0

load_wave('/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/arm1.wav')