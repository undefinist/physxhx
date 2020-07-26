let project = new Project('physx', __dirname);

if(platform == Platform.Windows)
{
    project.addFile('lib/Windows/**');
    project.addIncludeDir('lib/Windows/include');
    project.addLib('lib/Windows/lib/**');
}

resolve(project);
