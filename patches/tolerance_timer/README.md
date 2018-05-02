# Tolerance Timer
This patch adds a number of different timers to the game that aim at making the gameplay experience smoother, more user-friendly and more forgiving and also at reducing the impact of input lag. For this, it's making use of a number of different tricks I've learned while working in the professional games industry. So far, the patch supports two different features that can be enabled and disabled independently.

- Late jumps
- Early jumps

Use ttconfig.cfg to configure the patch and enable or disable features. Refer to the comments in the file for explanations on each setting.

**Late Jumps**

This feature adds a timer to the game that counts down while Mario is in the air (in other words, not touching the ground) and resets while Mario is on the ground. If Mario is currently in the air and the timer hasn't reached zero yet, a press of the A or B button will make him jump as if he was still on the ground. The purpose of this is to make jump controls smoother and more forgiving, especially in environments with noticable input lag (such as BSNES or Higan) by having button presses that arrive slightly too late still result in a jump. Even environments with low or no input lag (ZSNES, original hardware) will benefit from this. This patch is great for making precise jumps (1 block width) a lot less frustrating. The default setting for the timer is 3 frames, which is equal to about 50 ms of tolerance.

**Early Jumps**

This feature adds a timer to the game that counts down while Mario is in the air and not pressing any jump button and resets when Mario presses a jump button while still in the air. If Mario touches the ground and the timer hasn't reached zero yet, he immediately jumps again. The purpose of this is to make jump controls smoother and more forgiving by having button presses that arrive slightly too early still result in a jump. This does little in helping with input lag, but still makes the controls feel more responsive to the player. The default setting for the timer is 3 frames, which is equal to about 50 ms of tolerance.
