import click
import os
import filecmp
import shutil

def getSourceFiles():
	trgFiles = dict()
	target_dir ="alises"
	parent_dir = os.getcwd()
	abs_path = parent_dir+"/"+target_dir
	srcFiles = os.listdir(abs_path)
	
	for srcF in srcFiles:
		if srcF not in trgFiles.keys():
			trgFiles["."+srcF] = {
				"realName": srcF,
				"absPath": abs_path + "/" + srcF,
				"path": abs_path
			}

	return trgFiles

def getTargetLocationFiles(path):
	homeFiles = dict()
	hFiles = os.listdir(path)

	for file in hFiles:
		if file not in homeFiles.keys():
			homeFiles[file] = path + "/" + file
	
	return homeFiles

def notFoundFilesMsg(files):
	msg = list()

	msg.append("The following alias file[s] are not in the target location:")
	for f in files:
		msg.append("  - "+f)
	msg.append("If you want to 'install' them there run: 'python main.py --action install")

	click.echo(click.style("\n\n*********************NOT FOUND*****************************",fg="red"))
	for m in msg:
		click.echo(m)
	click.echo(click.style("***********************************************************",fg="red"))

def diffFoundMsg(diffFiles,diff=False):
	msg = list()
	fgColor = ""

	match diff:
		case True:
			msg.append("-- Differences:")
			fgColor = "yellow"
		case False:
			msg.append("-- No difference:")
			fgColor = "green"


	for f in diffFiles:
		msg.append(f'{f[0]} vs {f[1]}')
	
	for m in msg:
		click.echo(click.style(m,fg=fgColor))
	print()

def backupFile(dstFile):
	click.echo(click.style(f'Backing up file{dstFile}',fg="blue"))
	os.rename(dstFile, dstFile+".bak")

def updateFiles(srcFile, dstFile):
	#1.Make a backup of current file in destination
	backupFile(dstFile)
	#2 Copy source file into destination file
	click.echo(click.style(f'Updating file{dstFile}',fg="green"))
	print()
	shutil.copy(srcFile,dstFile)

def updateAliases():
	notFoundFiles = list()
	dffFiles=list()
	sameFiles=list()
	target_alises = getSourceFiles()
	home_files = getTargetLocationFiles(os.environ.get('HOME'))
	
	for ta in target_alises.keys():
		if ta in home_files.keys():
			#If files are not the same(aka there is a diff)
			if not filecmp.cmp(target_alises[ta]["absPath"],home_files[ta],shallow=False):
				dffFiles.append( (target_alises[ta]["absPath"], home_files[ta]) )
			else:
				sameFiles.append( (target_alises[ta]["absPath"], home_files[ta]) )
			
		else:
			notFoundFiles.append(ta)
	
	if dffFiles:
		diffFoundMsg(dffFiles,diff=True)
		for files in dffFiles:
			updateFiles(files[0], files[1])
	
	if sameFiles:
		diffFoundMsg(sameFiles)
	
	if notFoundFiles:
		notFoundFilesMsg(notFoundFiles)

@click.command()
@click.option('--action', help="Actions to be perform on alise files.")
def main(action):

	if(action == "update"):
		updateAliases()	

	else:
		msg="You either passed an option not valid or no option at all."
		click.echo(click.style(msg,fg="magenta"))