import dbus
import math

bus = dbus.SessionBus()

try:
	player = bus.get_object('org.kde.amarok', '/Player')
	
	status = player.GetStatus()
	
	output = ''
	
	playback = {0:'playing', 1:'paused', 2:'stopped'}
	onOff = {0:'off', 1:'on'}
	
	if status[0] != 2:
		data = player.GetMetadata()
		position = player.PositionGet()
		
		pos_str = ''
		
		if position:
			position /= 1000
			min = position / 60
			sec = str(position - min * 60)
			if len(sec) == 1:
				sec = '0' + sec
			pos_str = str(min) + ':' + str(sec)
		
		if data:
			total_min = data['time'] / 60
			total_sec = str(data['time'] - total_min * 60)
			if len(total_sec) == 1:
				total_sec = '0' + total_sec
			output = data['artist'] + ' - ' + data['title'] + ' | ' + pos_str + ' / ' + str(total_min) + ':' + str(total_sec)
		
		trackList = bus.get_object('org.kde.amarok', '/TrackList')
		
		output += ' | #' + str(trackList.GetCurrentTrack()) + ' / ' + str(trackList.GetLength()) + ' | '
		
		output += playback[status[0]] + ' | random: ' + onOff[status[1]]
	else:
		output = playback[status[0]]
	
	print output
except:
	print
