/**
 * FingerBeat v1.3.0 - Game Event Bus
 * Publish-subscribe pattern event bus for game event communication.
 * Module-level singleton.
 */

import { GameEventType } from '../model/GameTypes';
import { Logger } from '@ohos/common';

type EventCallback = (data?: Object) => void;

class GameEventBus {
  private subscribers: Map<GameEventType, EventCallback[]> = new Map();

  /**
   * Register a callback for a specific event type.
   */
  on(eventType: GameEventType, callback: EventCallback): void {
    let callbacks = this.subscribers.get(eventType);
    if (callbacks === undefined) {
      callbacks = [];
      this.subscribers.set(eventType, callbacks);
    }
    callbacks.push(callback);
    Logger.info(`GameEventBus.on: registered callback for ${GameEventType[eventType]}`);
  }

  /**
   * Unregister a callback for a specific event type.
   */
  off(eventType: GameEventType, callback: EventCallback): void {
    const callbacks = this.subscribers.get(eventType);
    if (callbacks === undefined) {
      return;
    }
    const index = callbacks.indexOf(callback);
    if (index !== -1) {
      callbacks.splice(index, 1);
      Logger.info(`GameEventBus.off: unregistered callback for ${GameEventType[eventType]}`);
    }
  }

  /**
   * Emit an event with optional data to all registered callbacks.
   */
  emit(eventType: GameEventType, data?: Object): void {
    const callbacks = this.subscribers.get(eventType);
    if (callbacks === undefined || callbacks.length === 0) {
      return;
    }
    for (const callback of callbacks) {
      try {
        callback(data);
      } catch (e) {
        Logger.error(`GameEventBus.emit: callback error for ${GameEventType[eventType]} - ${e}`);
      }
    }
  }

  /**
   * Clear all subscribers.
   */
  clear(): void {
    this.subscribers.clear();
    Logger.info('GameEventBus.clear: all subscribers cleared');
  }
}

/** Module-level singleton */
export const gameEventBus = new GameEventBus();
