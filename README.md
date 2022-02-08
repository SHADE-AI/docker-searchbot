# docker-searchbot

This is our cooperative efforts to get the searchbot running in a docker container. 
It currnetly works for CPU in Docker and Singularity.  More instructions to follow

Command to run searchbot vs 6 random bot game in interactive docker (very slow on CPU, more than 3 minutes per turn):

`python run.py --adhoc --cfg conf/c01_ag_cmp/cmp.prototxt I.agent_one=agents/searchbot.prototxt I.agent_six=agents/random.prototxt`
