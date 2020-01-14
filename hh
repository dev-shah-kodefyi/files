	if (campus.getGenielist() != null) {
			
			campus.getGenielist().forEach(g ->{
				genieentity.setGenieStatus(g.isGenieStatus());
				genieentity.setGenieDescription(g.getGenieDescription());
				genielist.add(genieentity);

			});
			}
        	genieentity.setCampus(campusentity);
			campusentity.setGenielist(genielist);
			campusRepositary.save(campusentity);
		

		return modelMapper.map(campusentity, CampusDto.class);
