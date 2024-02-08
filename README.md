--- intenção para projeto ----
efetuar interface flutter para conversão de audio em texto utilizando Whisper! 

---- Etapa inicial -----

Neste código e feito para que usa layout amigavel para converter audios em ".wav"!
formato que FFMPEG aceita para converter em texto.
Ao invez de montar diversas linhas de comando para poder converter com o FFMPEG, você
usará uma interface com botões indicando local de origem e local de destino para a conversão! 

---- requisitos ----
suporta windows 7,8,10 e 11.
Para isso é recomendado converter usando o FFMPEG, um programa em linha de comando
maravilhoso para fazer tudo que você puder imaginar com áudio e vídeo.

Para instalar o FFMPEG são necessários alguns passos simples:
1.	Crie um diretório FFMPEG na raiz do seu disco C:
2.	Acesse o repositório (https://github.com/BtbN/FFmpeg-Builds/releases) e baixe o arquivo ffmpeg-master-latest-win64-gpl.zip
3.	Descompacte o conteúdo do arquivo no diretório C:\FFMPEG. Cuidado para não criar pastas extras, as pastas bin e doc devem ficar logo abaixo da FFMPEG, em C:\FFMPEG\bin
4.	Na janela de pesquisa do Windows, digite “prompt de comando” e selecione a opção “Executar como Administrador”
5.	No prompt, digite:  setx path "%path%;C:\ffmpeg\bin" /m
6.	Se a mensagem de que o valor especificado foi salvo for exibida, feche a janela, e reinicie seu computador.
7.	Abra uma janela de prompt de comando normal e digite ffmpeg -version
8.	Caso a instalação tenha sido bem-sucedida.
9.	clone e execute em seu terminal favorito usando "flutter run -d windows".
