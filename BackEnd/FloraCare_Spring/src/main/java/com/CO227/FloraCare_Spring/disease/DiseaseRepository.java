package com.CO227.FloraCare_Spring.disease;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DiseaseRepository extends JpaRepository<Disease, Long> {
    Disease findByDiseaseName(String name);
}
