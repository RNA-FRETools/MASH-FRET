---
layout: default
title: Use the mapping tool
parent: /video-processing/functionalities.html
grand_parent: /video-processing.html
nav_order: 2
---

# Use the mapping tool
{: .no_toc }

The mapping tool allows to manually localize the position of a single emitter in each video channel and is accessed by pressing 
![Map](../../assets/images/gui/VP-but-map.png "Map") in the 
[Coordinates transformation](../panels/panel-molecule-coordinates#coordinates-transformation) panel of module Video processing.
It is used to map the reference coordinates needed to calculate the spatial transformation and export them to a 
[.map file](../../output-files/map-mapped-coordinates.html).
It is an adaptation of the 
[Control Point Selection tool](https://www.mathworks.com/help/images/ref/cpselect.html) of MATLAB for images containing more than two channels.

<a href="../../assets/images/gui/VP-panel-molcoord-transf-maptool.png"><img src="../../assets/images/gui/VP-panel-molcoord-transf-maptool.png" style="max-width: 546px;"/></a>

To map and export the reference coordinates, follow the procedure described below.

## Procedure
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Import and visualize the reference image

### Reference image
{: .no_toc }

A reference image must show luminescent objects visible in all channels. 
Usually, the average image of a video showing fluorescent beads is used; see 
[Average image](../panels/panel-molecule-coordinates.html#average-image) for more information about exporting an average image. 

The reference image file is requested after pressing 
![Map](../../assets/images/gui/VP-but-map.png "Map") and prior opening the mapping tool.
Supported file formats are:
* Portable Network Graphics (<u>.png</u>)
* Tagged Image File format (<u>.tif</u>)

After importing the image, the Mapping tool opens.


### Display
{: .no_toc }

The image display is divided horizontally according to the number of video channels defined in 
[Number of video channels](../panels/panel-experiment-settings.html#number-of-video-channels).

Full-length images of each channel are shown on the bottom and close-ups of the respective images are shown on the top.
Parts of the images shown in close-ups are indicated by a red rectangle on the full-length images.

You can slide the rectangle along the full-length image with the sliding bars located on the right-hand side of the close-ups.

Any graphics in MASH can be exported to an image file by left-clicking on the axes and selecting `Export graph`.


---

## Localize single emitters

If a single emitter is visible in all video channel, localize it in the close-up of the left-most channel by simply clicking on the brightest pixel.
The emitter is correctly localized only if a colored cross appears at the selected position along with a numbered label.

<img src="../../assets/images/figures/VP-maptool-emitter-localization.png" style="max-width:300px;"/>

Numbered labels give the localization order of all positions and are shown on the full-length images.

If the position was mistargeted, go to `Menu` in the menu bar and select `Delete last point`.
This will cancel the last selection.

Repeat the localization of the same emitter in all other channels to complete the mapping of this emitter.
You can cancel the localization of the last emitter in all channels by going to `Menu` in the menu bar and selecting `Delete last set`.

Map a consequent number of emitters in the reference image using the sliding bars to move through the image and considering the minimum number required for the transformation; see 
[Tranformation types](../panels/panel-molecule-coordinates.html#transformation-types) for an exhaustive list of minimum number of reference coordinates required for each transformation type.
The goal is to cover the whole image area in an homogeneous fashion in order to give an accurate representation of the space in each channel.

| inhomogeneous mapping                                                                                  | homogeneous mapping                                                                                  |
| :----------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------: |
| the mapping over-represents the right-hand side of the image                                           | the mapping is sufficient and relatively homogeneous                                                 |
| <img src="../../assets/images/figures/VP-maptool-inhomogeneous-mapping.png" style="max-width:200px;"/> | <img src="../../assets/images/figures/VP-maptool-homogeneous-mapping.png" style="max-width:200px;"/> |

---

## Export mapped coordinates

To export mapped coordinates to a 
[.map file](../../output-files/map-mapped-coordinates.html), simply close the mapping tool or go to `Menu` in the menu bar and select `Close and save`.

If the number of emitters mapped in the reference image is insufficient to use certain transformation types, a dialogue box will pop up to inform you.

<img src="../../assets/images/gui/VP-panel-molcoord-transf-maptool-msgbox.png" style="max-width:404px;"/>

Press 
![No](../../assets/images/gui/VP-but-no.png "No") to continue mapping and extend the number of emitters or press 
![Yes](../../assets/images/gui/VP-but-yes.png "Yes") to export the present set of mapped coordinates.

After export, the newly created 
[.map file](../../output-files/map-mapped-coordinates.html) is automatically imported in panel
[Coordinates transformation](../panels/panel-molecule-coordinates.html#coordinates-transformation) to calculates the spatial transformation.

