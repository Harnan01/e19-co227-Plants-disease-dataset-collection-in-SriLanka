package com.CO227.FloraCare_Spring.disease;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
public class DiseaseService {

    @Autowired
    private final DiseaseRepository diseaseRepository;

    public Disease findDiseaseByName(String name) {
        return diseaseRepository.findByDiseaseName(name);
    }
}
