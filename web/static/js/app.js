const Player = {
  id:    document.querySelector('meta[name = "player-id"]').content,
  token: document.querySelector('meta[name = "player-token"]').content
};

// initialize Elm application
const App = Elm.fullscreen(Elm.Main, {
  playerId: Player.id,
  playerJoinedEvent: { id: "", name: "" },
  playerLeftEvent: "",
  cardPickedEvent: { playerId: "", card: 0 }
});

// initialize channel socket
import {Socket} from 'phoenix';
const socket = new Socket('/socket', {
  params: { token: Player.token }
});

var channel;

App.ports.joinRoomEvent.subscribe(([room, player]) => {
  socket.connect();

  channel = socket.channel('rooms:' + room.name, {
    name: player.name
  });

  channel.join()
    .receive('ok', () => {
      console.log('Joined channel #' + room.name);
      App.ports.playerJoinedEvent.send(player);
    })
    .receive('error', response => {
      console.log('Error while joining channel #' + room.name, response);
    });

  channel.on("player_joined", (player) => {
    console.log('Player joined:', player);
    App.ports.playerJoinedEvent.send(player);
  });

  channel.on("player_left", (player) => {
    console.log('Player left:', player);
    App.ports.playerLeftEvent.send(player.id);

    if (player.id === Player.id) {
      channel.leave();
      channel = undefined;
    }
  });

  channel.on("card_picked", (pick) => {
    console.log('Card picked:', pick);
    App.ports.cardPickedEvent.send(pick);
  });
});

App.ports.leaveRoomEvent.subscribe((playerId) => {
  channel.push("player_left", { id: playerId });
});

App.ports.pickCardEvent.subscribe((card) => {
  channel.push("card_pick", { card: card });
});
