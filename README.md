# Custom Playfield scenecontrol

Scenecontrol to provide more extensive control over the ArcCreate playfield.

## > Installation

1. If there isn't one already, create a "Scenecontrol" (case-sensitive) folder within your chart folder
2. [Download the latest .zip](https://github.com/bagofbeanes/custom-playfield-scenecontrol/archive/refs/heads/main.zip)
3. Extract the .zip contents into the "Scenecontrol" folder
4. If necessary, combine the `init.lua` with that of other scenecontrols.

## > Features

- Creating and manipulating custom playfields
- Setting the number of lanes a track has
- Playfield skinning

## > Documentation

> [!NOTE]
> This scenecontrol is not configurable in the editor and requires a basic understanding of the Lua language and the ArcCreate scenecontrol API.

<hr>

### > Playfield creation, manipulation

- With this scenecontrol, you create your own playfields (container for a track, an extra track and the sky input line). `init.lua` creates one for you by default.
- To create a new playfield, use `Playfield:new(<skin>, <max_lane_count>, <ignoreoptions>)`.<br/>

  - `skin`: You can select a skin from the provided `SkinList` module. By default these are ArcCreate's preexisting track skins, but you can create your own as well (explained later on).
  - `max_lane_count`: The maximum amount of lanes a playfield can hold. This will be the cap for both the regular and the extra track.
  - `ignoreoptions`: Options for skipping creation of specified playfield elements. Use `SelectOptions()` and as its arguments, list your selection from the `IgnoreOptions` class (e.g. `SelectOptions(IgnoreOptions.trackEdgeL, IgnoreOptions.trackEdgeR)`)

- The playfield contains controllers which control their own elements. These controllers are:
  - `playfieldController`: Controls the entire playfield
  - `trackController`: Controls just the normal track and its elements
  - `trackExtraController`: Controls just the extra track and its elements, deactivated on creation
  - `skyInputController`: Controls sky input elements
- `trackBody`, for example, is controlled by `trackController` while `skyInputLine` is controlled by `skyInputController`.

- The track's scroll speed is determined by the first BPM in the chart. To use a different BPM for this, change `BASE_BPM` in `custom_playfield/main.lua`.

<hr>

### > Playfield element parenting

- For the most part, playfield elements behave like normal Controllers. Parenting is an exception.
- To parent a playfield element to a Controller (or the other way around), you use `ControllerObject.setParentC(<child>, <parent>)`.<br/>
  
  - `child`: The Controller or playfield element (ControllerObject) to be parented
  - `parent`: The parent Controller or playfield element (ControllerObject)

<hr>

### > Track lane count

- This scenecontrol makes it possible to set the number of lanes a track has, on both the normal and the extra track.
- To set the lane count of the normal track, use `<playfield_name>:setLaneCount(<lane_count>, <start_timing>, <end_timing>, <easing>)`.<br/>
  To set it on the extra track, use `<playfield_name>:setExtraLaneCount(<lane_count>, <start_timing>, <end_timing>, <easing>)`.<br/>

  - `lane_count`: The number of lanes to set to (any number from 0 to `maxLaneCount`)
  - `start_timing`: The start timing of the lane tween (in ms)
  - `end_timing`: The end timing of the lane tween (in ms). Optional; if omitted, `start_timing` will be used as the end timing.
  - `easing`: The easing type to use for the lane tween. Optional; if omitted, linear easing will be used.

- You can use `Context.laneFrom` and `Context.laneTo` to modify the range of the floor input.
- You can also use `Context2.skyInputHeight` to modify the maximum height of the sky input.
- Both floor and sky input ranges apply globally and cannot be set per playfield.

<hr>

### > Playfield skinning

- As previously mentioned, this scenecontrol allows the skinning of each playfield. By default, there are built-in skins which use ArcCreate's assets, accessible via the `SkinList` module.
- To expand this list, go to `custom_playfield/skinlist.lua` and create your own skin using a format similar to the following:
  
```lua
skin_list.skinname = PlayfieldSkin:new(

    'skinname', -- track
    'skinname', -- critical line
    'editor', -- track edge
    'editor', -- lane divider
    'skinname', -- extra track
    'skinname', -- extra critical line
    'skinname', -- extra track edge
    'editor', -- extra track lane divider
    'editor', -- sky input line
    'editor' -- sky input label

)
```

- ...where `editor` is a unique skin ID which just copies the specified skin element from the editor.
- Custom skin elements are stored in the `custom_playfield/sprites/skins/` folder. The relative path from here makes up a skin's ID.
  - As an example, to create your own skin, you would create a new folder (at `custom_playfield/skins/skinname`), then place all of your skin elements in there. From there, you access them by typing just `skinname` as the ID. For skin elements in a subfolder within `skinname` (let's say `variant_a` and `variant_b`), you access them by typing `skinname/variant_a` and `skinname/variant_b` respectively as the full skin IDs.
  - The default ArcCreate skins use the `default` ID, containing each default track skin type in its own sub-ID, like `conflict` and `light`. The full skin IDs for these are `default/conflict` and `default/light` respectively.
  - Within `default` there's also a `criticalline` folder with its own subfolders containing all critical line (floor judgement line) types. The remaining sprites (such as sky input line, track lane divider) are in `default` in case needed, but in this skin's case, skin elements not dependent on side/track skin are provided by the editor settings.

- The names of the skin elements are as follows:
  - Regular track:
    - Body: `TrackBody.png`
    - Critical line: `TrackCriticalLine.png`
    - Edge: `TrackEdge.png`
    - Lane divider: `TrackLaneDivider.png`
  - Extra track:
    - Body: `TrackExtraBody.png`
    - Critical line: `TrackExtraCriticalLine.png`
    - Edge: `TrackExtraEdge.png`
    - Lane divider: `TrackExtraLaneDivider.png`
  - Sky input:
    - Line: `SkyInputLine.png`
    - Label: `SkyInputLabel.png`
- It's advised to use the textures in `default` as templates for your own skin elements.

<hr>
