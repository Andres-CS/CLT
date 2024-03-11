
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
    exit()


# Set Logging
myUUID = uuid.uuid4()

try:
    filepath = str(os.getenv("LOGPATH"))+str(os.getenv("LOGFILE"))
    logger.basicConfig(
        filename=filepath, 
        level=logger.DEBUG,
        format=f'%(levelname)s::{myUUID}::%(message)s',
        datefmt='%a, %d %b %Y %H:%M:%S'
    )
except:
    print("ERROR - could not set logger")
    exit()