## s a n d s i f t e r 
: the x86 processor fuzzer

### Overview

* Sandsifter audits x86 processors for hidden instructions and hardware bugs by systematically generating machine code to search through a processor's instruction set, and monitoring execution for anomalies. See [the original repo](https://github.com/xoreaxeaxeax/sandsifter) for full details and references. 
* Originally developed by Christopher Domas (xoreaxeaxeax).
* This fork modifies Sandsifter to use the Intel XED disassembler instead of Capstone, significantly reducing the rate of false positives (as Capstone has incomplete coverage of the ISA). The Python command-line interface (sifter.py) and summarizer (summarize.py) are currently **unsupported** due to the lack of official Python bindings for XED - do not use them when XED is enabled in the configuration. Instead, use the injector directly as described below.
* To switch back to the Capstone disassembler so the sifter and summarizer are supported, set useXed to false in the Makefile.

### Building

This repo requires Intel XED. Install XED with the following:

```
git clone https://github.com/intelxed/xed.git xed
git clone https://github.com/intelxed/mbuild.git mbuild
cd xed
./mfile.py install
```

This will create a folder in the 'kits' directory with a name containing your OS and the date (e.g. 'xed-install-base-2019-04-05-lin-x86-64'). Edit the configuration section of this repo's Makefile so that kitLocation is the relative filepath of this kit folder from this repo, and microarch is the XED name for your CPU's microarchitecture (see the [XED documentation](https://intelxed.github.io/ref-manual/xed-chip-enum_8h_source.html) for the available options; use XED_CHIP_ALL if you're not sure). Ensure there are no spaces between the values you enter and the '#' beginning the line comment.

The repo can then be built with:

```
make
```

### Usage
To run a scan with the injector:

```
sudo ./injector -P1 -t -0
```

To filter the results of a direct injector invocation, grep can be used. For example,

```
sudo ./injector -P1 -r -0 | grep '\.r' | grep -v sigill
```

searches for instructions for which the processor and disassembler disagreed
on the instruction length (grep '\.r'), but the instruction successfully
executed (grep -v sigill).

### Flags

```
-b
	mode: brute force

-r
	mode: randomized fuzzing

-t
	mode: tunneled fuzzing

-d
	mode: externally directed fuzzing

-R
	raw output mode

-T
	text output mode

-x
	write periodic progress to stderr

-0
	allow null dereference (requires sudo)

-D
	allow duplicate prefixes

-N
	no nx bit support

-s seed
	in random search, seed value

-B brute_depth
	in brute search, maximum search depth

-P max_prefix
	maximum number of prefixes to search

-i instruction
	instruction at which to start search (inclusive)

-e instruction
	instruction at which to end search (exclusive)

-c core
	core on which to perform search

-X blacklist
	blacklist the specified instruction

-j jobs
	number of simultaneous jobs to run

-l range_bytes
	number of base instruction bytes in each sub range
```
