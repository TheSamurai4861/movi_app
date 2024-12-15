import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:http/http.dart' as http;
import 'package:movi_mobile/core/constants/api.dart';
import 'dart:convert';

class PlayerScreen extends StatefulWidget {
  final dynamic media;
  final int? season; // Saison pour les épisodes (facultatif)
  final int? episode;

  const PlayerScreen(
      {super.key, required this.media, this.season, this.episode});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final Player player;
  late final VideoController controller;
  late final String streamingUrl;
  late Duration _currentPosition = Duration.zero;
  bool _showControls = true; // Variable pour gérer l'affichage des contrôles
  late Duration _mediaDuration = Duration.zero; // Durée totale du média
  List<AudioTrack>? _audioTracks; // Initialize here
  List<SubtitleTrack>? _subtitleTracks;
  bool _isPlaying = false;
  int watchTime = 0;

  @override
  void initState() {
    super.initState();

    // Force landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Initialize player and video controller
    player = Player();
    controller = VideoController(player);

    // Listen to position updates and save them
    player.stream.position.listen((position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    });

    // Listen to the total duration of the media
    player.stream.duration.listen((duration) {
      if (mounted) {
        setState(() {
          _mediaDuration = duration;
        });
      }
    });

    player.stream.playing.listen((playing) {
      if (mounted) {
        setState(() {
          _isPlaying = playing;
        });
      }
    });

    // Listen to available audio tracks
    player.stream.tracks.listen((event) {
      _audioTracks = event.audio;
      if (mounted) {
        setState(() {}); // Update the state
      }
    });

    // Listen to available subtitle tracks
    player.stream.tracks.listen((event) {
      if (mounted) {
        setState(() {
          _subtitleTracks = event.subtitle;
        });
      }
    });

    // Open the media and seek to the last watched position
    _initializeAndPlay();
  }

  Future<void> _initializeAndPlay() async {
    try {
      final isMovie = widget.season == null && widget.episode == null;
      final url = isMovie
          ? '${Api.apiUrl}resolve?tmdb_id=${widget.media.tmdb}&language=fr&quality=1080'
          : '${Api.apiUrl}resolve?tmdb_id=${widget.media.tmdb}&language=fr&quality=1080&season=${widget.season}&episode=${widget.episode}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final videoUrl = data['url'];
        final headers = Map<String, String>.from(data['headers']);
        player.open(Media(videoUrl, httpHeaders: headers));
      }
    } catch (e) {
      setState(() {
        _isPlaying = false;
      });
    }

    // Listen for when the player is ready
    player.stream.duration.listen((duration) async {
      if (duration != Duration.zero) {
        // If there is a valid saved watch time, seek to that position
        if (watchTime > 0) {
          print('$watchTime seconds');
          await player.seek(Duration(seconds: watchTime));
        }

        // Démarrer le timer pour masquer les contrôles après 5 secondes
        _startHideControlsTimer();
      }
    });
  }

  @override
  void dispose() {
    player.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  void _startHideControlsTimer() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControlsVisibility() {
    setState(() {
      _showControls = !_showControls;
    });

    // Démarrer ou redémarrer le timer de masquage
    _startHideControlsTimer();
  }

  // Fonction pour sauter à un moment spécifique
  void _seekToRelativePosition(Offset localPosition, double width) {
    final double relative = localPosition.dx / width;
    final Duration seekPosition = _mediaDuration * relative;
    player.seek(seekPosition);
  }

  void _showAudioTrackSelection() {
    showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData.dark().copyWith(
            dialogBackgroundColor: Colors.grey[800],
          ),
          child: AlertDialog(
            title: const Text('Langues',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 24)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _audioTracks
                        ?.where((track) => track.language != null)
                        .map((track) {
                      return ListTile(
                        title: Text(track.language!,
                            style: const TextStyle(color: Colors.white)),
                        onTap: () {
                          player.setAudioTrack(track);
                          Navigator.pop(context);
                        },
                      );
                    }).toList() ??
                    [],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSubtitleTrackSelection() {
    showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData.dark().copyWith(
            dialogBackgroundColor: Colors.grey[800],
          ),
          child: AlertDialog(
            title: const Text('Sous-titres',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 24)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('Off',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      player.setSubtitleTrack(SubtitleTrack.no());
                      Navigator.pop(context);
                    },
                  ),
                  ..._subtitleTracks
                          ?.where((track) => track.language != null)
                          .map((track) {
                        return ListTile(
                          title: Text(track.language!,
                              style: const TextStyle(color: Colors.white)),
                          onTap: () {
                            player.setSubtitleTrack(track);
                            Navigator.pop(context);
                          },
                        );
                      }).toList() ??
                      [],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _getPlayingState() {
    return _isPlaying;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleControlsVisibility, // Affiche ou masque les contrôles
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Affichage de la vidéo
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 9.0 / 16.0,
              child: Video(
                controller: controller,
                controls: (state) {
                  return const SizedBox(); // Pas de contrôles intégrés
                },
                subtitleViewConfiguration: const SubtitleViewConfiguration(
                  style: TextStyle(
                    height: 1.4,
                    fontSize: 40.0,
                    letterSpacing: 0.0,
                    wordSpacing: 0.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Color.fromARGB(41, 0, 0, 0),
                  ),
                  textAlign: TextAlign.center,
                  padding: EdgeInsets.all(24.0),
                ),
              ),
            ),
          ),
          // Contrôles (close, play/pause, barre de progression)
          if (_showControls)
            AnimatedOpacity(
              opacity: _showControls ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Stack(
                children: [
                  // Barre de progression
                  Positioned(
                    bottom: 55,
                    left: 30,
                    right: 30,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        _seekToRelativePosition(
                          details.localPosition,
                          MediaQuery.of(context).size.width -
                              40, // Largeur ajustée
                        );
                      },
                      onTapDown: (details) {
                        // Pour permettre à un tap direct sur la barre d'initier le seek
                        _seekToRelativePosition(
                          details.localPosition,
                          MediaQuery.of(context).size.width - 40,
                        );
                      },
                      child: Container(
                        height: 20,
                        color: Colors.transparent,
                        child: Stack(
                          children: [
                            // Fond gris plus sombre pour la durée totale
                            Container(
                              width: MediaQuery.of(context).size.width - 40,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.grey[700],
                                borderRadius:
                                    BorderRadius.circular(10), // Coins arrondis
                              ),
                            ),
                            // Barre de progression
                            Positioned(
                              left: 0,
                              child: Container(
                                width:
                                    (MediaQuery.of(context).size.width - 40) *
                                        (_currentPosition.inSeconds /
                                            (_mediaDuration.inSeconds == 0
                                                ? 1
                                                : _mediaDuration.inSeconds)),
                                height: 8,
                                decoration: BoxDecoration(
                                  color: const Color(
                                      0xFF755CFF), // Couleur violette
                                  borderRadius: BorderRadius.circular(
                                      10), // Coins arrondis
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Bouton Close en haut à gauche
                  Positioned(
                    top: 40,
                    left: 30, // Position avec 20 pixels de marge
                    child: GestureDetector(
                      onTap: () {
                        // Sauvegarder la position actuelle avant de quitter
                        // widget.media.timeWatched = _currentPosition.inSeconds;
                        context.pop();
                      },
                      child: Image.asset(
                        'assets/icons/back.png',
                        height: 25,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // Bouton pause/play
                  Center(
                    child: IconButton(
                      onPressed: () {
                        player.playOrPause();
                      },
                      icon: _getPlayingState()
                          ? Image.asset(
                              'assets/icons/pause.png',
                              height: 40,
                              fit: BoxFit.contain,
                            )
                          : Image.asset(
                              'assets/icons/play.png',
                              height: 35,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 30,
                    right: 30,
                    child: DefaultTextStyle(
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      child: Row(
                        children: [
                          // Temps écoulé
                          Text(_formatDuration(_currentPosition)),
                          const SizedBox(width: 4),
                          const Text('/'),
                          const SizedBox(width: 4),
                          // Temps total
                          Text(_formatDuration(_mediaDuration)),
                          const Spacer(),
                          Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[700],
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.subtitles,
                                  color: Colors.white, size: 20),
                              onPressed: _showSubtitleTrackSelection,
                              tooltip: 'Select Subtitle',
                            ),
                          ),
                          // Bouton pour sélectionner la piste audio
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[700],
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.audiotrack,
                                  color: Colors.white, size: 20),
                              onPressed: _showAudioTrackSelection,
                              tooltip: 'Select Audio Track',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
