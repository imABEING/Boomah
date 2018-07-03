<Cabbage>
form caption("Booma"), size(600, 400), pluginid("Booma"), colour("109,80,123,0")
image file("watergirls.jpg"), bounds("0, 0, 600, 400"), alpha(.7)
label align("centre"), bounds(350, 250, 250, 45), alpha(.75), colour("0,0,0,0"), fontcolour("0,192,192"), text("@rolexalexx"), tofront()

;Keyboard
keyboard bounds(0, 300, 600, 100)

;Ampl Envelope
rslider bounds (100, 100, 100, 100), channel("att"), text("Attack"), colour("0,0,0,0"), trackercolour(255,105,180), range(0, 1, .01, 1, .01)
rslider bounds (200, 100, 100, 100), channel("dec"), text("Decay"), colour("0,0,0,0"), trackercolour("0,255,0"), range(0, 1, .5, 1, .01)
rslider bounds (300, 100, 100, 100), channel("sus"), text("Sustain"), colour("0,0,0,0"), trackercolour("0,255,0"), range(0, 1, .2, 1, .01)
rslider bounds (400, 100, 100, 100), channel("rel"), text("Release"), colour("0,0,0,0"), trackercolour(255,105,180), range(0, 1, .3, 1, .01)

;Output Gain
vslider bounds (540, 20, 40, 100), channel("gain"), trackercolour(255,105,180), range(0, 1, .7, .5, .01)

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac     ;;;realtime audio out
;-iadc    ;;;uncomment -iadc if RT audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o poscil.wav -W ;;; for file output any platform
-dm0 -n -+rtmidi=null -M0

--midi-key-cps=3
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs  = 1

seed 0
;gisine ftgen 0, 0, 2^10, 10, 1

gisine   ftgen 1, 0, 16384, 10, 1	;sine wave
gisquare ftgen 2, 0, 16384, 10, 1, 0 , .33, 0, .2 , 0, .14, 0 , .11, 0, .09 ;odd harmonics
gisaw    ftgen 3, 0, 16384, 10, 0, .2, 0, .4, 0, .6, 0, .8, 0, 1, 0, .8, 0, .6, 0, .4, 0,.2 ;even harmonics

instr 1

;MIDI IN
icps cpsmidi

asig  poscil .8, icps, gisine


;gkAtt = .01
gkAtt = 0.01
gkDec = 0.5
gkSus = 0.3
gkRel = 0.2

gkAtt = chnget:k("att")
gkDec = chnget:k("dec")
gkSus = chnget:k("sus")
gkRel = chnget:k("rel")



;aenv  adsr i(gkAtt), i(gkDec), i(gkSus), i(gkRel)
aenv	linsegr		0, i(gkAtt),1, i(gkDec), i(gkSus), i(gkRel), 0	

ktrig	changed	gkAtt, gkDec, gkSus, gkRel
 if ktrig==1 then
  reinit	UpdateEnv
 endif
 UpdateEnv:
 gkAtt		=	i(gkAtt)
 gkDec		=	i(gkDec)
 gkSus		=	i(gkSus)
 gkRel		=	i(gkRel)
 rireturn


kGain = chnget:k("gain")
;kGain = .5


aL = asig*aenv
aR = asig*aenv

;aL	*=	ampdb(kgain)
;aR	*=	ampdb(kgain)

      outs aL*kGain, aR*kGain

endin

</CsInstruments>
<CsScore>
i1 0 z
e
</CsScore>
</CsoundSynthesizer>

<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
