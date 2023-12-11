package haxe.ui.backend;

import haxe.Timer;
import openfl.Lib;
import openfl.events.Event;

class TimerImpl {
    static private var __timers:Array<TimerImpl> = [];

    static public function update(e:Event) {
        var currentTime:Float = Timer.stamp();
        var count:Int = __timers.length;
        for (i in 0...count) {
            var timer:TimerImpl = __timers[i];
            if (timer._start <= currentTime && !timer._stopped) {
                timer._start = currentTime + (timer._delay / 1000);
                timer._callback();
            }
        }

        while (--count >= 0) {
            var timer:TimerImpl = __timers[count];
            if (timer._stopped) {
                timer._callback = null;
                __timers.remove(timer);
            }
        }

        if (__timers.length == 0) {
            Lib.current.stage.removeEventListener(Event.ENTER_FRAME, update);
        }
    }

    private var _callback:Void->Void;
    private var _start:Float;
    private var _stopped:Bool;
    private var _delay:Int;

    public function new(delay:Int, callback:Void->Void) {
        this._callback = callback;
        _delay = delay;
        _start = Timer.stamp() + (delay / 1000);
        __timers.push(this);
        if (__timers.length == 1) {
            Lib.current.stage.addEventListener(Event.ENTER_FRAME, update);
        }
    }

    public function stop() {
        _stopped = true;
    }
}