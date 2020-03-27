# PPRMeta

Tool repo: [PPR-Meta](https://github.com/zhenchengfang/PPR-Meta)

We run this tool in a docker containter but not using CWL docker support. We wrapped the docker container in a bash script.

## Docker image

Taken from: [https://github.com/replikation/What_the_Phage/blob/master/phage-tool-Dockerfiles/PPR-Meta/Dockerfile](https://github.com/replikation/What_the_Phage/blob/master/phage-tool-Dockerfiles/PPR-Meta/Dockerfile)

## Singularity image

Build based on the docker image: ```singularity build pprmeta.img docker://mbcebi/pprmeta:1.0```

## Run

```bash
$ singularity run pprmeta.img <contigs.fasta> <output.csv>
```
