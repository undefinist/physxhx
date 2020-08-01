let project = new Project('physxhx', __dirname);

project.addIncludeDir('lib/include');
project.addIncludeDir('src/linc/include');
project.addFile('src/linc/include/ExtCpuWorkerThreadHx.cpp');
project.addFile('src/linc/include/ExtDefaultCpuDispatcherHx.cpp');

if(platform == Platform.Windows)
{
    project.addLib('lib/Windows/lib/**');
}

resolve(project);
