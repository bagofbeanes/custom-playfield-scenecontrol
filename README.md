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
skin_list.exampleskin = PlayfieldSkin:new(

    'exampleskin', -- track
    'exampleskin', -- critical line
    'editor', -- track edge
    'editor', -- lane divider
    'exampleskin', -- extra track
    'exampleskin', -- extra critical line
    'exampleskin', -- extra track edge
    'editor', -- extra track lane divider
    'editor', -- sky input line
    'editor' -- sky input label

)
```

- Skin elements are stored in the `custom_playfield/sprites/skins/` folder. The relative path from here makes up a skin's ID.
  - As an example, to create your own skin, you would create a new folder (at `custom_playfield/sprites/skins/exampleskin`), then place all of your skin elements in there. From there, you access them by typing just `exampleskin` as the ID. For skin elements in a subfolder within `exampleskin` (let's say `variant_a` and `variant_b`), you access them by typing `exampleskin/variant_a` and `exampleskin/variant_b` respectively as the full skin IDs.
  - The built-in skins use the `builtin` ID, which contains each default track skin type in its own sub-ID, like `conflict` and `light`. Therefore the full skin IDs for them are `builtin/conflict` and `builtin/light` respectively.
  - Within `builtin` there's also a `criticalline` folder with its own subfolders containing all types of critical line, and also within `builtin` are the remaining skin elements (such as sky input line, track lane divider) in case needed, but by default, skin elements not dependent on side/track skin are provided by the editor settings for `builtin` skins.
- `editor` is a unique skin ID which copies the specified skin element from the editor.

- List of all skin elements:
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
- The textures used in the `builtin` skin may be used as templates for your own skins.

<hr>
