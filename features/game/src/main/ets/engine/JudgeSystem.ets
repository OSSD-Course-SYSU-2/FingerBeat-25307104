/**
 * FingerBeat v1.3.0 - Judge System
 * Determines judgment grade based on time offset and finds nearest unjudged note.
 */

import { JudgmentGrade, JudgmentWindows, RuntimeNote, NoteType } from '../model/GameTypes';
import { Logger } from '@ohos/common';

class JudgeSystem {
  private windows: JudgmentWindows;

  constructor(windows: JudgmentWindows) {
    this.windows = windows;
    Logger.info(`JudgeSystem: initialized with P=${windows.perfectWindow} G=${windows.greatWindow} Go=${windows.goodWindow}`);
  }

  /**
   * Judge the time offset and return the corresponding judgment grade.
   * @param timeOffset - Time difference in ms (positive = late, negative = early)
   * @returns JudgmentGrade based on absolute offset
   */
  judge(timeOffset: number): JudgmentGrade {
    const absOffset = Math.abs(timeOffset);
    if (absOffset <= this.windows.perfectWindow) {
      return JudgmentGrade.PERFECT;
    } else if (absOffset <= this.windows.greatWindow) {
      return JudgmentGrade.GREAT;
    } else if (absOffset <= this.windows.goodWindow) {
      return JudgmentGrade.GOOD;
    } else {
      return JudgmentGrade.MISS;
    }
  }

  /**
   * Find the nearest unjudged TAP note within the goodWindow for a given lane.
   * @param lane - Lane index to search
   * @param currentTime - Current game time in ms
   * @param notes - Array of runtime notes to search
   * @param goodWindow - Good judgment window in ms
   * @returns The nearest unjudged TAP note, or null if none found
   */
  findNearestNote(lane: number, currentTime: number, notes: RuntimeNote[], goodWindow: number): RuntimeNote | null {
    let nearestNote: RuntimeNote | null = null;
    let nearestOffset: number = Infinity;

    for (const note of notes) {
      if (note.isJudged) {
        continue;
      }
      if (note.lane !== lane) {
        continue;
      }
      if (note.type !== NoteType.TAP) {
        continue;
      }
      const offset = Math.abs(note.targetTime - currentTime);
      if (offset <= goodWindow && offset < nearestOffset) {
        nearestOffset = offset;
        nearestNote = note;
      }
    }

    return nearestNote;
  }
}

export default JudgeSystem;
