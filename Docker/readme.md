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

**CMD** 

**ENTRYPOINT** 