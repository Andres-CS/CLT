
import os
import uuid
import logging as logger
from dotenv import load_dotenv


# Load .env file
try:
    cwd = os.getcwd()
    parentDir = os.pardir
    root=os.path.abspath(os.path.join(cwd,parentDir))
    # print(root+"/.env")

    load_dotenv()
except:
    print("ERROR - .env file could not be loaded.")
    exit(code=0)


# Set Logging
myUUID = uuid.uuid4()

try:
    filepath = str(os.getenv("LOGPATH"))+str(os.getenv("LOGFILE"))
    logger.basicConfig(
        filename=filepath, 
        level=logger.DEBUG,
        format=f'%(levelname)s::%(asctime)s::{myUUID}::%(message)s',
    )
except:
    print("ERROR - could not set logger")
    exit(code=0)