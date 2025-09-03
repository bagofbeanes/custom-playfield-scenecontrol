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
> This scenecontrol is not configurable in the editor and expects a basic understanding of the Lua language and the ArcCreate scenecontrol API.

<hr>

### > Playfield creation and manipulation

- The original playfield is removed, meaning you need to create your own. The `init.lua` creates one for you by default, but you may want to customize it or add more.
- To create a new playfield, use `Playfield:new()`.<br/>
  This method has 2 parameters: `skin` and `max_lane_count`.

  - `skin`: You can select a skin from the provided `skin_list` module. By default these are ArcCreate's preexisting track skins, but you can create your own as well (explained further below).
  - `max_lane_count`: Determines the maximum amount of lanes a playfield can hold. This will be the cap for both the regular and the extra track.

- Use the playfield's fields to transform and manipulate it. The key elements are:
  - `playfieldController`: Controls the entire playfield
  - `trackController`: Controls just the regular track and its elements
  - `trackExtraController`: Controls just the extra (6k) track and its elements, deactivated on creation
  - `skyInputController`: Controls all sky input elements
- There are other elements besides these that control the inner parts of the playfield (e.g. `trackBody`, controls just the regular track body and none of its elements).

- The track's speed is based on the first BPM of the chart. If you need a different base BPM, change `BASE_BPM` in `main.lua`.

<hr>

### > Playfield element parenting

- Playfield elements behave like normal Controllers for the most part. One of the exceptions is parenting.
- If you want to parent a playfield element to a Controller or parent a Controller to it, you'll need to use `ControllerObject.setParentC()`.<br/>
  This method has 2 parameters: `child` and `parent`.
  
  - `child`: The Controller or playfield element (`ControllerObject`) to be parented
  - `parent`: The parent Controller or playfield element (`ControllerObject`)

<hr>

### > Track lane count

- You can set the number of lanes a track has, for both the regular and the extra track.
- To set the lane count of the regular track, use `<playfield_name>:setLaneCount()`.<br/>
  To set it on the extra track, use `<playfield_name>:setExtraLaneCount()`.<br/>
  Both have 4 parameters: `lane_count`, `start_timing`, `end_timing` and `easing`.

  - `lane_count`: The number of lanes to display (any number from 0 to `maxLaneCount`)
  - `start_timing`: The start timing of the lane animation (in ms)
  - `end_timing`: The end timing of the lane animation (in ms). Optional; if omitted, `start_timing` will be used as the end timing.
  - `easing`: The easing type to use for the lane animation. Optional; if omitted, a linear easing type will be used.

- It's important to mention here that you can use `Context.laneFrom` and `Context.laneTo` to modify the range of the floor input indicator.
- This scenecontrol adds an additional field: `Context.skyInputHeight`, which controls the maximum height of the sky input indicator.

<hr>

### > Playfield skinning

- As mentioned above, this scenecontrol also allows the skinning of the playfield. There are built-in skins which use ArcCreate's assets, accessible via the `skin_list` module.
- To add to this list, go to `custom_playfield/skinlist.lua` and create your own skin using this format:
  
```lua
skin_list.skinname = PlayfieldSkin:new(

    'builtin/light', -- track
    'editor', -- critical line
    'builtin/light', -- track edge
    'editor', -- lane divider
    'builtin/light', -- extra track
    'editor', -- extra critical line
    'builtin/light', -- extra track edge
    'editor', -- extra track lane divider
    'editor', -- sky input line
    'editor' -- sky input label

)
```

- This is just a basic light side skin, but you can change the IDs to other built-in ones or add your own skin elements (explained below).
  
- Skin elements are stored in the folder `custom_playfield/sprites/skins/`. The folder names from here make up the skin IDs.
  - As an example, to create your own skin, you create a new folder (let's say `exampleskin`) at the path above. Then, if you place all of your skin elements in here, you simply access them by typing `exampleskin` as the ID. If you choose to place some skin elements in their own folder (let's say `abc`) within `exampleskin/`, you would access those with `exampleskin/abc` as the full skin ID.
  - The built-in skins use the `builtin` ID, which contains all default track skin types in its own sub-ID, for example `conflict` or `light`. Therefore the full skin IDs for them are `builtin/conflict` and `builtin/light` respectively.
  - There's also a `criticalline` sub-ID containing all types of critical lines as well as all other skin elements under the `builtin` skin ID in case needed, but by default, skin elements not dependent on side/track skin are provided by the editor for `builtin` skins.
- `editor` is a special skin ID used when you want the skin element to be taken from the skin set in the editor.

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
    - Lane divider: `TrackLaneDivider.png`
  - Sky input:
    - Line: `SkyInputLine.png`
    - Label: `SkyInputLabel.png`
- You can find example images for all skin elements in the `builtin/` folder. As mentioned earlier, critical line types are stored under `builtin/criticallines/`.

<hr>
