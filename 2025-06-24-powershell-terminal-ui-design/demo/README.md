# PwshSpectreConsole Demo

This demo will showcase how easy it can be to create beautiful, interactive console applications using the PwshSpectreConsole module in PowerShell.

## Demo Overview

> **Scenario**  
> We're going to take docker, a common command line tool and automate some of the tasks we may like to help others with. We can build a small wizard with the functionality below.  
> We will also interact with a web API to get details for some container images we may want to preview on the command line.

1. Writing some header text with `Write-SpectreFigletText`
2. Horizontal rules and panels with `Write-SpectreRule`
3. Tables for container details with `Format-SpectreTable`
4. Selecting action with `Read-SpectreSelection` 
5. Selecting multiple containers with `Read-SpectreMultiSelection`
6. Wait spinner for stop/starting containers with `Invoke-SpectreCommandWithStatus`
7. Layout for logs with `New-SpectreLayout`
8. Live tailing log data with our layout and `Invoke-SpectreLive`
9. Browsing the docker api to show a list of images we could pull:
   - Get popular container images.
   - Display the images in a table.
   - Show the logo for each on the left side of the table.
   - Show the name of the image with `Write-SpectreHost -PassThru` with a link to the image.
   - Show the star count for each image.
   - Show the download count for each image.
10. Provide a list of the images with `Read-SpectreSelection` and when selected, pull the image using `docker pull`.

The docker api endpoints to use:
 - Get popular images with https://hub.docker.com/v2/repositories/library/?page=1&page_size=10
 - Get the logo urls for each container image https://hub.docker.com/api/media/repos_logo/v1/{urlencoded_repo_name}, then use this url with `Get-SpectreImage`.

## Closing

What we've missed, charts, trees, grids, etc. there is much more to look at, check it out for yourself and reach out if you have questions!