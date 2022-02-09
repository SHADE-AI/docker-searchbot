# docker-searchbot

This is our cooperative efforts to get the searchbot running in a docker container. 
It currnetly works for CPU in Docker and Singularity.  More instructions to follow

Command to run searchbot vs 6 random bot game in interactive docker (very slow on CPU, more than 3 minutes per turn):

`python run.py --adhoc --cfg conf/c01_ag_cmp/cmp.prototxt I.agent_one=agents/searchbot.prototxt I.agent_six=agents/random.prototxt`

To run on Frontera simply get an interactive job with the idev command on a rtx node

`idev -t 2:00:00 -p rtx`

Then before starting any container (it needs a place to save games and singularity containers are read only) 

```
c199-021[rtx](1002)$ mkdir /tmp/adhoc
c199-021[rtx](1002)$ singularity run --nv docker://ngaffney/searchbot
INFO:    Using cached SIF image
Singularity> cd /diplomacy_searchbot/
```

And all should be ready to run.
