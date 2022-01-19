
1. Run the command below and it will create a container. You can see in the terminal the logs its producing. It's the default behavior of docker. Now run cmd + C to stop the container. Check the terminal for the logs.
> docker-compose up

2. Run the command below to start the container in a detached mode. You can check Docker for Desktop for the container information. --build rebuilds the whole image and recreates the container.
> docker-compose up -d --build
