let project = new Project('physx', __dirname);

if(platform == Platform.Windows)
{
    project.addAssets('lib/Windows/dll/**');
}

resolve(project);
