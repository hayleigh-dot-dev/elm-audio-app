import { Elm } from './elm/Main.elm'
import VirtualAudioGraph from './js/virtual-audio'

// We need this because safari and older versions of chrome use the webkit
// prefix.
const AudioContext = window.AudioContext || window.webkitAudioContext

const context = new AudioContext()
const audio = new VirtualAudioGraph(context)

// These days, an audio context starts in a suspended state and must be 
// explicitly resumed after some user interaction event. This is a catch-all
// solution. Ideally you'll create a port and do this inside the elm application
// whenever it is most appropriate.
window.onclick = () => {
  if (context.state === 'suspended') audio.resume()
}

const app = Elm.Main.init({
  node: document.querySelector('#app'),
  flags: context
})

app.ports.updateAudio.subscribe(graph => {
  audio.update(graph)
})
