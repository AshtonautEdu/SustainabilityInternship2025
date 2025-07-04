2025-07-04 Progress Report

I've had a good read into open research principles, which should help keep my work structured and documented, and make it more accessible and reproducible for others. "As open as possible, as closed as necessary"
- In general, fully documenting my work as I go along will go a long way towards this. 
- FAIR (findable, accessible, interoperable, reusable) principles are also key. Some suggestions towards implementation include:
	- Making use of an appropriate repository, which should also help with persistent identifiers.
	- Prolific use of metadata. Schemas and ontologies exist that can ensure the metadata itself is also FAIR.
	- Appropriate licensing.
	- Adhering to standards (e.g. for access and data formats) where possible, ideally open-source.
- Putting work on GitHub and making use of the kanban board also contributes towards open research. My progress can be looked at, and opportunity for input, feedback and collaboration is increased.
- It is ideal if someone else is able to take my work (including data, code and documentation) and reproduce my results. Towards improving reproducibility, some suggestions are:
	- Again, proper documentation.
	- Making use of open-source software where possible, and documenting used versions.
	- Encoding processes in scripts where possible so they can be used again (particularly pertinent for analyses and figure generation).
	- Possibly making use of containerisation, workflow managers, and research object crates

I created a transcription script capable of transforming audio to text, as well as assigning speaker labels to different voices.
- I chose WhisperX for its high performance, accuracy, and diarisation (speaker labelling) functionality. 
- It turned out that WhisperX requires an older Python version. I learned to use Conda to create a virtual environment allowing me to use Python 3.11
	- This gave me some first-hand experience into why dependency management is so important, since I didn't want to replace Python across my whole machine.

I got to grips with the basics of using Aire.
- I learned to connect to Aire, and then how to transfer files between Aire and my laptop.
- I read into the different node types that make up Aire, and how they interact with each other.
- I learned how to create a SLURM job script and submit it
	- Following on from this, I learned some basic MPI programming. I used this in a test script to see if I was correctly submitting jobs across different cores and nodes in Aire.

Next steps?
- I'm keen to have a look at how I'll approach benchmarking. I need to dig into what metrics are available and relevant to measure (which could differ between Aire and the test machine next to me), and read into how best to conduct the benchmarks themselves. After this, I think I can start constructing some tests.