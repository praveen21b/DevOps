# Virtual Environment

## Creating Virtual Environment

```python
# creates the virtual environment and saves the file at the current working directory.
python3 -m venv venv_name
```
## Activate the Virtual Environment on Linux

```shell
source venv_name/bin/activate
```

# Dockerfile

## RUN, CMD, and ENTRYPOINT
**RUN** used when we need to install the packages or dependencies. It adds addition layer of instructions to the image.
>e.g. **_RUN pip install -r requirements.txt_**

>**IMP: CMD Vs ENTRYPOINT**
>
>Lets create a conatiner (with image: **_praveen21b/flast-hello-world:v0.3.0_**) with command `docker run -d -p 5000:5000 praveen21b/flast-hello-world:v0.3.0` and this is what we do regularly. Now, lets understand that in our Dockerfile we have used `CMD` command to run python file `app.py`. When I add an additinal command to the above docker run command like here `docker run -d -p 5000:5000 praveen21b/flast-hello-world:v0.3.0 ping google.com`, the `ping google.com` command overrides our application output and hence we wont see our application output at all instead ther will be the ping outputs. **So, the preceding command overrides our `CMD ["python3", "app.py"]` command mentioned in the Dockerfile.***
>
>Lets modified out Dockerfile by replacing the `CMD` with `ENTRYPOINT` and create the new image from it and now run the command `docker run -d -p 5000:5000 praveen21b/flast-hello-world:v0.3.0 ping google.com`, this results in no overriding of our application command.
>
>**_Hence, use `CMD` when you want to override the command while running the container else use `ENTRYPOINT`._**
