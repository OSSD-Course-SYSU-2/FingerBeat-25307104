/**
 * FingerBeat v1.3.0 - Note Scheduler
 * Manages note position updates, visibility, and missed note detection.
 */

import { RuntimeNote, NoteData, JudgmentGrade } from '../model/GameTypes';
import { NOTE_VISIBLE_AHEAD_TIME, NOTE_VISIBLE_BEHIND_TIME, JUDGMENT_LINE_RATIO } from '../constants/GameConstants';
import { Logger } from '@ohos/common';

interface MissedNoteInfo {
  id: string;
  lane: number;
}

class NoteScheduler {
  private scrollSpeed: number;
  private judgmentLineY: number;
  private notes: RuntimeNote[] = [];

  constructor(scrollSpeed: number, judgmentLineY: number) {
    this.scrollSpeed = scrollSpeed;
    this.judgmentLineY = judgmentLineY;
    Logger.info(`NoteScheduler: initialized scrollSpeed=${scrollSpeed} judgmentLineY=${judgmentLineY}`);
  }

  /**
   * Load notes from beatmap data into runtime notes.
   */
  loadNotes(noteDataList: NoteData[]): void {
    this.notes = noteDataList.map((noteData: NoteData): RuntimeNote => {
      return {
        id: noteData.id,
        lane: noteData.lane,
        targetTime: noteData.targetTime,
        type: noteData.type,
        holdDuration: noteData.holdDuration,
        endLane: noteData.endLane,
        currentY: 0,
        isJudged: false,
        isVisible: false,
      };
    });
    Logger.info(`NoteScheduler.loadNotes: loaded ${this.notes.length} notes`);
  }

  /**
   * Get all runtime notes.
   */
  getNotes(): RuntimeNote[] {
    return this.notes;
  }

  /**
   * Update note positions and visibility based on current time.
   * @param currentTime - Current game time in ms
   * @param screenHeight - Screen height in px
   */
  update(currentTime: number, screenHeight: number): void {
    const judgmentY = screenHeight * JUDGMENT_LINE_RATIO;

    for (const note of this.notes) {
      if (note.isJudged) {
        note.isVisible = false;
        continue;
      }

      // Calculate time difference: positive means note is ahead (above), negative means past
      const timeDiff = note.targetTime - currentTime;

      // Position: notes scroll from top to judgment line
      // When timeDiff > 0, note is above judgment line
      // When timeDiff = 0, note is at judgment line
      // When timeDiff < 0, note is below judgment line
      const pixelsPerMs = this.scrollSpeed * (screenHeight / 1000);
      note.currentY = judgmentY - timeDiff * pixelsPerMs;

      // Visibility: note is visible if within the visible time window
      note.isVisible = timeDiff <= NOTE_VISIBLE_AHEAD_TIME && timeDiff >= -NOTE_VISIBLE_BEHIND_TIME;
    }
  }

  /**
   * Check for notes that have been missed (passed beyond the good window).
   * @param currentTime - Current game time in ms
   * @param goodWindow - Good judgment window in ms
   * @returns Array of missed note IDs with lane info
   */
  checkMissedNotes(currentTime: number, goodWindow: number): MissedNoteInfo[] {
    const missed: MissedNoteInfo[] = [];

    for (const note of this.notes) {
      if (note.isJudged) {
        continue;
      }
      // Note is missed if it has passed beyond the good window
      if (currentTime - note.targetTime > goodWindow) {
        note.isJudged = true;
        note.isVisible = false;
        const info: MissedNoteInfo = { id: note.id, lane: note.lane };
        missed.push(info);
      }
    }

    if (missed.length > 0) {
      Logger.info(`NoteScheduler.checkMissedNotes: ${missed.length} notes missed`);
    }

    return missed;
  }

  /**
   * Mark a note as judged by its ID.
   * @param noteId - The ID of the note to mark
   */
  markNoteJudged(noteId: string): void {
    for (const note of this.notes) {
      if (note.id === noteId) {
        note.isJudged = true;
        note.isVisible = false;
        return;
      }
    }
    Logger.warn(`NoteScheduler.markNoteJudged: note not found - ${noteId}`);
  }

  /**
   * Check if all notes have been judged.
   */
  areAllNotesJudged(): boolean {
    for (const note of this.notes) {
      if (!note.isJudged) {
        return false;
      }
    }
    return true;
  }

  /**
   * Get the count of unjudged notes.
   */
  getUnjudgedCount(): number {
    let count = 0;
    for (const note of this.notes) {
      if (!note.isJudged) {
        count++;
      }
    }
    return count;
  }
}

export default NoteScheduler;
